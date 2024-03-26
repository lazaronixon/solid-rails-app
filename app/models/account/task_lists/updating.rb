# frozen_string_literal: true

class Account::TaskLists::Updating < Solid::Process
  input do
    attribute :id, :integer
    attribute :name, :string
    attribute :account

    before_validation do
      self.name = name.strip
    end

    validates :id, numericality: {only_integer: true, greater_than: 0}
    validates :name, presence: true
    validates :account, instance_of: Account, persisted: true
  end

  def call(attributes)
    id, name, account = attributes.values_at(:id, :name, :account)

    case Account::TaskLists::Editing.call(account:, id:)
    in Solid::Failure(type:, value:)
      Failure(type, **value)
    in Solid::Success(task_list:)
      task_list.update!(name:)

      Success(:task_list_updated, task_list:)
    end
  end
end
