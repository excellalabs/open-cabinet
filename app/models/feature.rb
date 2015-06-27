class Feature < ActiveRecord::Base
  extend Flip::Declarable

  strategy Flip::SessionStrategy
  # strategy Flip::DeclarationStrategy
  default false

  feature :alternate_cabinet,
          description: 'Alternative Cabinet'
end
