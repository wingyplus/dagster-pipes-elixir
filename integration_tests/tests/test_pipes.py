from dagster_pipes_tests import PipesTestSuite


class TestElixirPipes(PipesTestSuite):
    BASE_ARGS = ["../dagster_pipes/test.sh"]
