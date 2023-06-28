require 'rails_helper'

RSpec.describe Cat, type: :model do
  
  it "should validate name" do
    cat = Cat.create
    expect(cat.errors[:name]).to_not be_empty
  end
  
  it 'cat enjoys is at least 10 characters long' do
    cat = Cat.create name:'Larson', age: 4, enjoys: 'Fur', image: 'https://images.unsplash.com/photo-1492370284958-c20b15c692d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1049&q=80'
    expect(cat.errors[:enjoys]).to_not be_empty
  end



end
