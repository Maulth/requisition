class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user
        scope.where(user: @user)
      else
        scope.none
      end
    end
  end

  def show?
    @record.user == @user
  end

  def create?
    @user && @user.can_place_order?
  end
end
