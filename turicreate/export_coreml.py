import turicreate as tc

model = tc.load_model('cats-dogs.model')

model.export_coreml('KaggleCatsDogsClassifier.mlmodel')