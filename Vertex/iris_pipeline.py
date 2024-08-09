import kfp
from kfp.v2 import dsl
from kfp.v2.dsl import Dataset, Model, Output
from kfp.v2 import compiler

@dsl.component(
    base_image="python:3.9",
    packages_to_install=["pandas", "scikit-learn", "joblib"]
)
def train_model(output_model: Output[Model]):
    from sklearn import datasets
    from sklearn.model_selection import train_test_split
    from sklearn.linear_model import LogisticRegression
    import joblib

    # Load the IRIS dataset
    iris = datasets.load_iris()
    X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2)

    # Train a Logistic Regression model
    model = LogisticRegression(max_iter=200)
    model.fit(X_train, y_train)

    # Save the trained model
    joblib.dump(model, output_model.path + "/model.joblib")

@dsl.pipeline(
    name="iris-classification-pipeline",
    pipeline_root="gs://your-gcs-bucket/pipeline_root/"
)
def iris_pipeline():
    train_model_op = train_model()

# Compile the pipeline
compiler.Compiler().compile(
    pipeline_func=iris_pipeline,
    package_path="pipeline.json"  # This generates the pipeline.json file
)
