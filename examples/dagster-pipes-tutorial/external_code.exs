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

    report_asset_materialization(context, %{
      total_orders: total_orders
    })
  end
end

DagsterPipes.open(&Main.run/1, [])
