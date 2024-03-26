# frozen_string_literal: true

class Account::TaskLists::Editing < Solid::Process
  input do
    attribute :id, :integer
    attribute :account

    validates :id, numericality: {only_integer: true, greater_than: 0}
    validates :account, instance_of: Account, persisted: true
  end

  def call(attributes)
    id, account = attributes.values_at(:id, :account)

    task_list = account.task_lists.find_by(id: id)

    return Failure(:task_list_not_found) unless task_list

    return Failure(:inbox_cannot_be_edited) if task_list.inbox?

    Success(:task_list_found, task_list:)
  end
end
