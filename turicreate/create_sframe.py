
import turicreate as tc

data = tc.image_analysis.load_images('PetImages', with_path=True)

data['label'] = data['path'].apply(lambda path: 'dog' if '/Dog' in path else 'cat')

data.save('cats-dogs.sframe')