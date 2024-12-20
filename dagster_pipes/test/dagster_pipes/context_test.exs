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

  describe "report_asset_materialization/4" do
    test "report asset materialization", %{context: context} do
      Context.report_asset_materialization(
        context,
        %{hello: %DagsterPipes.PipesMetadataValue{type: :__infer__, raw_value: "world"}},
        nil,
        nil
      )

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :opened,
        params: %{}
      }

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :report_asset_materialization,
        params: %{
          metadata: %{hello: %{"type" => "__infer__", "raw_value" => "world"}},
          asset_key: "elixir_pipes",
          data_version: nil
        }
      }
    end

    test "not allowed to report asset twice", %{context: context} do
      metadata = %{hello: %{type: :__infer__, raw_value: "world"}}

      assert :ok = Context.report_asset_materialization(context, metadata)
      assert {:error, :already_reported} = Context.report_asset_materialization(context, metadata)

      {:messages, messages} = Process.info(self(), :messages)
      assert [%{method: :opened}, %{method: :report_asset_materialization}] = messages
    end

    test "report raw string value", %{context: context} do
      assert :ok = Context.report_asset_materialization(context, %{hello: "world"})

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :report_asset_materialization,
        params: %{
          metadata: %{hello: %{"type" => "text", "raw_value" => "world"}},
          asset_key: "elixir_pipes",
          data_version: nil
        }
      }
    end

    test "report raw integer value", %{context: context} do
      assert :ok = Context.report_asset_materialization(context, %{hello: 1})

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :report_asset_materialization,
        params: %{
          metadata: %{hello: %{"type" => "int", "raw_value" => 1}},
          asset_key: "elixir_pipes",
          data_version: nil
        }
      }
    end

    test "report raw boolean value", %{context: context} do
      assert :ok = Context.report_asset_materialization(context, %{hello: true})

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :report_asset_materialization,
        params: %{
          metadata: %{hello: %{"type" => "bool", "raw_value" => true}},
          asset_key: "elixir_pipes",
          data_version: nil
        }
      }
    end
  end
end
