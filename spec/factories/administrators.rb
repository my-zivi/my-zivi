FactoryBot.define do
  factory :administrator do
    organization
    association :user, strategy: :build, factory: %i[user confirmed]

    after(:create) do |civil_servant|
      civil_servant.user.save
    end
  end
end
