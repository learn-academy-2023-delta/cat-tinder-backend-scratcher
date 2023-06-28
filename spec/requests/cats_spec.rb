require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )

      # Make a request
      get '/cats'

      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do
    it "creates a cat" do
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Meow Mix, and plenty of sunshine.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
  
      # Send the request to the server
      post '/cats', params: cat_params
  
      # Assure that we get a success back
      expect(response).to have_http_status(201)
  
      # Look up the cat we expect to be created in the db
      cat = Cat.first
  
      # Assure that the created cat has the correct attributes
      expect(cat.name).to eq 'Buster'
    end
  end

  it "doesn't create a cat without a name" do
    cat_params = {
      cat: {
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    # Send the request to the  server
    post '/cats', params: cat_params
    # expect an error if the cat_params does not have a name
    expect(response.status).to eq 422
    # Convert the JSON response into a Ruby Hash
    json = JSON.parse(response.body)
    # Errors are returned as an array because there could be more than one, if there are more than one validation failures on an attribute.
    expect(json['name']).to include "can't be blank"
  end

  it "doesn't create a cat without enjoys." do
    cat_params = {
      cat: {
        name: 'Buster',
        age: 4,
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    
    # Send the request to the server
    post '/cats', params: cat_params
    
    # Expect an error if the cat_params are missing enjoys and image
    expect(response.status).to eq 422
    
    # Convert the JSON response into a Ruby Hash
    json = JSON.parse(response.body)
    
    # Expect the validation error messages for enjoys and image attributes
    expect(json['enjoys']).to include "can't be blank"
    
  end

  it "doesn't create a cat without age" do
    cat_params = {
      cat: {
        name: 'Buster',
        enjoys: 'Meow Mix, and plenty of sunshine.',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    
    # Send the request to the server
    post '/cats', params: cat_params
    
    # Expect an error if the cat_params is missing age
    expect(response.status).to eq 422
    
    # Convert the JSON response into a Ruby Hash
    json = JSON.parse(response.body)
    
    # Expect the validation error message for age attribute
    expect(json['age']).to include "can't be blank"
  end
  
  it "doesn't create a cat without image" do
    cat_params = {
      cat: {
        name: 'Buster',
        age: 4,
        enjoys: 'Meow Mix, and plenty of sunshine.',
      }
    }
    
    # Send the request to the server
    post '/cats', params: cat_params
    
    # Expect an error if the cat_params is missing enjoys
    expect(response.status).to eq 422
    
    # Convert the JSON response into a Ruby Hash
    json = JSON.parse(response.body)
    
    # Expect the validation error message for enjoys attribute
    expect(json['image']).to include "can't be blank"
  end
    
  describe "PATCH /cats/:id" do
    it "updates a cat" do
      cat = Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )
  
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: 'New Name',
          age: 3,
          enjoys: 'Playing with toys',
          image: 'https://new-image-url.com'
        }
      }
  
      # Send the request to the server
      patch "/cats/#{cat.id}", params: cat_params
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)
  
      # Reload the cat from the database
      cat.reload
  
      # Assure that the cat attributes have been updated
      expect(cat.name).to eq 'New Name'
      expect(cat.age).to eq 3
      expect(cat.enjoys).to eq 'Playing with toys'
      expect(cat.image).to eq 'https://new-image-url.com'
    end
  end

  describe "PATCH /cats/:id" do
    it "updates a cat with valid parameters" do
      cat = Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )
  
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: '', # Empty name to trigger validation error
          age: 3,
          enjoys: 'Playing with toys',
          image: 'https://new-image-url.com'
        }
      }
  
      # Send the request to the server
      patch "/cats/#{cat.id}", params: cat_params
  
      # Assure that we get a status of 422 (Unprocessable Entity)
      expect(response).to have_http_status(422)
  
      # Convert the JSON response into a Ruby Hash
      json = JSON.parse(response.body)
  
      # Expect the error message for the name attribute
      expect(json['name']).to include "can't be blank"
  
      # Reload the cat from the database
      cat.reload
  
      # Assure that the cat attributes have not been updated
      expect(cat.name).to eq 'Felix'
      expect(cat.age).to eq 2
      expect(cat.enjoys).to eq 'Walks in the park'
      expect(cat.image).to eq 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
    end
  end
  
  
  describe "DELETE /cats/:id" do
    it "destroys a cat" do
      cat = Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )
  
      # Send the request to the server
      delete "/cats/#{cat.id}"
  
      # Assure that we get a success back
      expect(response).to have_http_status(204)
  
      # Assure that the cat has been removed from the database
      expect { cat.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end