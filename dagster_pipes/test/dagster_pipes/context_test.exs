defmodule DagsterPipes.ContextTest do
  use ExUnit.Case, async: true

  alias DagsterPipes.Context

  setup do
    context =
      start_supervised!(
        {Context,
         params_loader: DagsterPipes.TestParamsLoader.init(pid: self()),
         context_loader: DagsterPipes.TestContextLoader,
         message_writer: DagsterPipes.TestMessageWriter}
      )

    %{context: context}
  end

  test "report_asset_materialization/4", %{context: context} do
    Context.report_asset_materialization(
      context,
      %{hello: %DagsterPipes.MetadataValue{raw_value: "world", type: "__infer__"}},
      nil,
      nil
    )

    assert_receive %DagsterPipes.Message{
      __dagster_pipes_version: "0.1",
      method: "opened",
      params: %{}
    }

    assert_receive %DagsterPipes.Message{
      __dagster_pipes_version: "0.1",
      method: "report_asset_materialization",
      params: %{
        metadata: %{hello: %DagsterPipes.MetadataValue{type: "__infer__", raw_value: "world"}},
        asset_key: "elixir_pipes",
        data_version: nil
      }
    }
  end
end
