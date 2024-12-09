from dagster import Definitions, PipesSubprocessClient, load_assets_from_modules

from dagster_pipes_tutorial import assets  # noqa: TID252

all_assets = load_assets_from_modules([assets])

defs = Definitions(
    assets=all_assets,
    resources={"pipes_subprocess_client": PipesSubprocessClient()}
)
