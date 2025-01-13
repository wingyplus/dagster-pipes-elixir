defmodule DagsterPipesTest do
  use ExUnit.Case
  doctest DagsterPipes

  describe "run/2" do
    setup do
      Process.flag(:trap_exit, true)

      %{
        opts: [
          params_loader: DagsterPipes.TestParamsLoader.init(pid: self()),
          context_loader: DagsterPipes.TestContextLoader,
          message_writer: DagsterPipes.TestMessageWriter
        ]
      }
    end

    test "return a message from a function", %{opts: opts} do
      fun = fn _context ->
        :ok
      end

      assert :ok = DagsterPipes.run(fun, opts)
    end

    test "function raise exception", %{opts: opts} do
      fun = fn _context ->
        raise "An error occurred."
      end

      assert_raise RuntimeError, fn -> DagsterPipes.run(fun, opts) end

      assert_receive %DagsterPipes.PipesMessage{
        dagster_pipes_version: "0.1",
        method: :closed,
        params: %{
          exception: %{
            "cause" => nil,
            "context" => nil,
            "message" => "An error occurred.",
            "name" => RuntimeError,
            "stack" => [_ | _]
          }
        }
      }
    end
  end
end
