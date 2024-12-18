defmodule MainTest do
  def run(argv \\ System.argv()) do
    argv
    |> parse_options([])
    |> execute()
  end

  def execute(options) do
  end

  def parse_options([], acc), do: Enum.into(acc, %{})

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
