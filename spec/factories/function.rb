Settings.add_source!("#{Rails.root}/config/settings/test.yml")
Settings.reload!

FactoryGirl.define do
  factory :function do
    uri Settings.functions.set_intensity.uri
    created_from Settings.user.uri
    name Settings.functions.set_intensity.name
  end

  factory :not_owned_function, parent: :function do
    created_from Settings.another_user.uri
  end

  factory :function_complete, parent: :function do |f|
    f.function_properties {[
      Factory.build(:function_status),
      Factory.build(:function_intensity)
    ]}
  end

  factory :function_status, class: :function_property do
    uri Settings.properties.status.uri
    value Settings.properties.status.default_value
    secret 'false'
    before 'false'
  end

  factory :function_intensity, class: :function_property do
    uri Settings.properties.intensity.uri
    value ''
    secret 'true'
    before 'true'
  end
end
