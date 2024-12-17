import shutil

from dagster import (
    AssetCheckSpec,
    AssetExecutionContext,
    MaterializeResult,
    PipesSubprocessClient,
    asset,
    file_relative_path,
)


@asset(check_specs=[AssetCheckSpec(name="total_orders", asset="subprocess_assets")])
def subprocess_assets(
    context: AssetExecutionContext, pipes_subprocess_client: PipesSubprocessClient
) -> MaterializeResult:
    cmd = [
        shutil.which("elixir"),
        file_relative_path(__file__, "../external_code.exs"),
    ]
    return pipes_subprocess_client.run(
        command=cmd, context=context
    ).get_materialize_result()
