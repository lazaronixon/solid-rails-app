# frozen_string_literal: true

class Account::TaskLists::Listing < Solid::Process
  input do
    attribute :account

    validates :account, instance_of: Account, persisted: true
  end

  def call(_)
    relation = input.account.task_lists.order(created_at: :desc)

    Success(:records_found, relation:)
  end
end
