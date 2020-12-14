# frozen_string_literal: true

class SysAdmin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :validatable,
         :lockable,
         :trackable
end
