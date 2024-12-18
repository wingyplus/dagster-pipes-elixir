defmodule DagsterPipes.DefaultContextLoader do
  @file_path_key "path"
  @direct_key "data"

  def load_context(%{@file_path_key => path}) when is_binary(path) do
    path
    |> File.read!()
    |> Jason.decode!()
  end

  def load_context(%{@direct_key => data}) when is_map(data) do
    data
  end
end

defmodule DagsterPipes.ContextLoader do
  @doc "Loads a context that injected by orchestrator process."
  def load_context(context_loader, params) do
    context_loader.load_context(params)
    |> DagsterPipes.PipesContextData.from_map()
  end
end

# DagsterPipes.Context.terminate(
#   {:function_clause,
#    [
#      {DagsterPipes.DefaultContextLoader, :load_context,
#       [
#         %{
#           "data" => %{
#             "asset_keys" => ["my_asset"],
#             "code_version_by_asset_key" => %{"my_asset" => nil},
#             "extras" => %{
#               "baz" => 1,
#               "corge" => nil,
#               "foo" => "bar",
#               "quux" => %{"a" => 1, "b" => 2},
#               "qux" => [1, 2, 3]
#             },
#             "job_name" => "__ephemeral_asset_job__",
#             "partition_key" => nil,
#             "partition_key_range" => nil,
#             "partition_time_window" => nil,
#             "provenance_by_asset_key" => %{"my_asset" => nil},
#             "retry_number" => 0,
#             "run_id" => "3828e8c2-3772-4f0c-9779-ccbdba88dff9"
#           }
#         }
#       ], [file: ~c"lib/dagster_pipes/context_loader.ex", line: 4]},
#      {DagsterPipes.ContextLoader, :load_context, 2,
#       [file: ~c"lib/dagster_pipes/context_loader.ex", line: 14]},
#      {DagsterPipes.Context, :handle_continue, 2,
#       [file: ~c"lib/dagster_pipes/context.ex", line: 97]},
#      {:gen_server, :try_handle_continue, 3, [file: ~c"gen_server.erl", line: 2335]},
#      {:gen_server, :loop, 7, [file: ~c"gen_server.erl", line: 2244]},
#      {:proc_lib, :init_p_do_apply, 3, [file: ~c"proc_lib.erl", line: 329]}
#    ]},
#   %DagsterPipes.Context{
#     context_data: nil,
#     message_channel: nil,
#     materialized_assets: MapSet.new([])
#   }
# )
