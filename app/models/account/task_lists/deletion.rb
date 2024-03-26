# frozen_string_literal: true

class Account::TaskLists::Deletion < Solid::Process
  self.input = Account::TaskLists::Editing::Input

  def call(attributes)
    case Account::TaskLists::Editing.call(attributes)
    in Solid::Failure(type:, value:)
      Failure(type, **value)
    in Solid::Success(task_list:)
      task_list.destroy!

      Success(:task_list_deleted, task_list:)
    end
  end
end
