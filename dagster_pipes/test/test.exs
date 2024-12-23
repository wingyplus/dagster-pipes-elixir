defmodule DagsterPipes.PipesTest do
  use GenServer

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, args)
  end

  def with_extras(pid, extras) do
    GenServer.call(pid, {:extras, extras})
  end

  def extras(pid) do
    GenServer.call(pid, :extras)
  end

  def with_full_test(pid) do
    GenServer.call(pid, :run_full_test)
  end

  def run_full_test?(pid) do
    GenServer.call(pid, :run_full_test?)
  end

  def with_job_name(pid, job_name) do
    GenServer.call(pid, {:job_name, job_name})
  end

  def job_name(pid) do
    GenServer.call(pid, :job_name)
  end

  def with_asset_materialization(pid, materialization) do
    GenServer.call(pid, {:asset_materialization, materialization})
  end

  def asset_materialization(pid) do
    GenServer.call(pid, :asset_materialization)
  end

  def with_asset_check(pid, asset_check) do
    GenServer.call(pid, {:asset_check, asset_check})
  end

  def asset_check(pid) do
    GenServer.call(pid, :asset_check)
  end

  def run(pid, context) do
    test_extras(extras(pid), DagsterPipes.Context.extras(context))
    test_job_name(job_name(pid), DagsterPipes.Context.job_name(context))
    test_asset_materialization(asset_materialization(pid), context)
    test_asset_check(asset_check(pid), context)
  end

  def test_extras(nil, _), do: :ok
  def test_extras(extras, extras), do: :ok

  def test_job_name(nil, _), do: :ok
  def test_job_name(job_name, job_name), do: :ok

  def test_asset_materialization(nil, _), do: :ok

  def test_asset_materialization(asset_materialization, context) do
    DagsterPipes.Context.report_asset_materialization(
      context,
      build_metadata(),
      asset_materialization["dataVersion"],
      asset_materialization["assetKey"]
    )
  end

  def test_asset_check(nil, _), do: :ok

  def test_asset_check(asset_check, context) do
    # test
    DagsterPipes.Context.report_asset_check(
      context,
      asset_check["checkName"],
      asset_check["passed"],
      severity_from_string(asset_check["severity"]),
      build_metadata(),
      asset_check["assetKey"]
    )
  end

  defp severity_from_string("WARN"), do: :WARN
  defp severity_from_string("ERROR"), do: :ERROR

  defp build_metadata() do
    %{
      float: 0.1,
      int: 1,
      text: "hello",
      notebook: DagsterPipes.MetadataValue.notebook("notebook.ipynb"),
      path: DagsterPipes.MetadataValue.path("/dev/null"),
      md: DagsterPipes.MetadataValue.markdown("**markdown**"),
      bool_true: true,
      bool_false: false,
      asset: DagsterPipes.MetadataValue.asset("foo/bar"),
      dagster_run: DagsterPipes.MetadataValue.dagster_run("db892d7f-0031-4747-973d-22e8b9095d9d"),
      null: nil,
      url: URI.parse("https://dagster.io"),
      json: %{
        "foo" => "bar",
        "baz" => 1,
        "qux" => [1, 2, 3],
        "quux" => %{"a" => 1, "b" => 2},
        "corge" => nil
      }
    }
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:extras, extras}, _from, state) do
    {:reply, :ok, Map.put(state, :extras, extras)}
  end

  @impl true
  def handle_call(:extras, _from, state) do
    {:reply, state[:extras], state}
  end

  @impl true
  def handle_call(:run_full_test, _from, state) do
    {:reply, :ok, Map.put(state, :full_test, true)}
  end

  @impl true
  def handle_call(:run_full_test?, _from, state) do
    {:reply, state.full_test, state}
  end

  @impl true
  def handle_call({:job_name, extras}, _from, state) do
    {:reply, :ok, Map.put(state, :job_name, extras)}
  end

  @impl true
  def handle_call(:job_name, _from, state) do
    {:reply, state[:job_name], state}
  end

  @impl true
  def handle_call({:asset_materialization, materialization}, _from, state) do
    {:reply, :ok, Map.put(state, :asset_materialization, materialization)}
  end

  @impl true
  def handle_call(:asset_materialization, _from, state) do
    {:reply, state[:asset_materialization], state}
  end

  @impl true
  def handle_call({:asset_check, asset_check}, _from, state) do
    {:reply, :ok, Map.put(state, :asset_check, asset_check)}
  end

  @impl true
  def handle_call(:asset_check, _from, state) do
    {:reply, state[:asset_check], state}
  end
end

defmodule MainTest do
  def run(argv \\ System.argv()) do
    argv
    |> parse_options([])
    |> execute()
  end

  def execute(options) do
    {:ok, pid} = DagsterPipes.PipesTest.start_link()
    pid = Enum.reduce(options, pid, &set_options/2)
    DagsterPipes.open(&DagsterPipes.PipesTest.run(pid, &1), [])
  end

  defp set_options({:extras, extras}, pid) do
    extras = extras |> File.read!() |> Jason.decode!()
    DagsterPipes.PipesTest.with_extras(pid, extras)
    pid
  end

  defp set_options({:full, true}, pid) do
    DagsterPipes.PipesTest.with_full_test(pid)
    pid
  end

  defp set_options({:job_name, job_name}, pid) do
    DagsterPipes.PipesTest.with_job_name(pid, job_name)
    pid
  end

  defp set_options({:report_asset_materialization, materialization_json_path}, pid) do
    materialization = materialization_json_path |> File.read!() |> Jason.decode!()
    DagsterPipes.PipesTest.with_asset_materialization(pid, materialization)
    pid
  end

  defp set_options({:report_asset_check, asset_check_path}, pid) do
    asset_check = asset_check_path |> File.read!() |> Jason.decode!()
    DagsterPipes.PipesTest.with_asset_check(pid, asset_check)
    pid
  end

  defp set_options(_, pid), do: pid

  def parse_options([], acc), do: acc

  def parse_options(["--context", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:context, value} | acc])
  end

  def parse_options(["--context=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:context, value} | acc])
  end

  def parse_options(["--messages", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:messages, value} | acc])
  end

  def parse_options(["--messages=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:messages, value} | acc])
  end

  def parse_options(["--env" | argv], acc) do
    parse_options(argv, [{:env, true} | acc])
  end

  def parse_options(["--jobName", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:job_name, value} | acc])
  end

  def parse_options(["--jobName=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:job_name, value} | acc])
  end

  def parse_options(["--extras", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:extras, value} | acc])
  end

  def parse_options(["--extras=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:extras, value} | acc])
  end

  def parse_options(["--full" | argv], acc) do
    parse_options(argv, [{:full, true} | acc])
  end

  def parse_options(["--custom-payload-path", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:custom_payload_path, value} | acc])
  end

  def parse_options(["--custom-payload-path=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:custom_payload_path, value} | acc])
  end

  def parse_options(["--report-asset-check", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:report_asset_check, value} | acc])
  end

  def parse_options(["--report-asset-check=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:report_asset_check, value} | acc])
  end

  def parse_options(["--report-asset-materialization", value | argv], acc)
      when is_binary(value) do
    parse_options(argv, [{:report_asset_materialization, value} | acc])
  end

  def parse_options(["--report-asset-materialization=" <> value | argv], acc)
      when is_binary(value) do
    parse_options(argv, [{:report_asset_materialization, value} | acc])
  end

  def parse_options(["--throw-error" | argv], acc) do
    parse_options(argv, [{:throw_error, true} | acc])
  end

  def parse_options(["--logging" | argv], acc) do
    parse_options(argv, [{:logging, true} | acc])
  end

  def parse_options(["--message-writer", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:message_writer, value} | acc])
  end

  def parse_options(["--message-writer=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:message_writer, value} | acc])
  end

  def parse_options(["--context-loader", value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:context_loader, value} | acc])
  end

  def parse_options(["--context-loader=" <> value | argv], acc) when is_binary(value) do
    parse_options(argv, [{:context_loader, value} | acc])
  end
end

MainTest.run()
