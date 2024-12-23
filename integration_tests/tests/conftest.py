import pytest
import subprocess


@pytest.fixture(scope="session", autouse=True)
def mix_compile():
    subprocess.run(
        ["mix", "cmd", "--cd", "../dagster_pipes", "mix do deps.get + compile"],
        check=True,
    )
