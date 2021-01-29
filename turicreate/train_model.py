import turicreate as tc

data = tc.SFrame('cats-dogs.sframe')

train_data, test_data = data.random_split(0.8)

model = tc.image_classifier.create(train_data, target='label')

predictions = model.predict(test_data)

metrics = model.evaluate(test_data)

print("Test set accuracy: ", metrics['accuracy'])

model.save('cats-dogs.model')

model.export_coreml('KaggleCatsDogsClassifier.mlmodel')