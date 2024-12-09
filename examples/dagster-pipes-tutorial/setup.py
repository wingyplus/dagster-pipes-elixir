from setuptools import find_packages, setup

setup(
    name="dagster_pipes_tutorial",
    packages=find_packages(exclude=["dagster_pipes_tutorial_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
