FactoryBot.define do
  factory :task do
    title { 'Task' }
    status { rand(2) }
    from = Date.parse("2019/08/01")
    to   = Date.parse("2019/12/31")
    deadline { Random.rand(from..to) }
  end

  trait :task_finished_status do
    status { :done }
    completion_date { Time.current.yesterday }
    association :project
  end
end
