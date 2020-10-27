require 'rails_helper'

shared_examples 'attacheable' do

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
