# This script ported from https://docs.dagster.io/concepts/dagster-pipes/subprocess.

Mix.install(
  [
    :explorer,
    {:dagster_pipes, path: "../../dagster_pipes"}
  ],
  force: true
)

defmodule Main do
  alias Explorer.DataFrame, as: DF

  import DagsterPipes

  def run(context) do
    orders_df = DF.new(%{order_id: [1, 2], item_id: [432, 878]})
    total_orders = DF.n_rows(orders_df)

    meta = %{
      total_orders: total_orders
    }

    report_asset_materialization(context, meta)
    report_asset_check(context, "total_orders", total_orders == 2, :ERROR, meta)
  end
end

DagsterPipes.run(&Main.run/1)
