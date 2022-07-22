class ChargesController < ApplicationController
  before_action :response_unauthorized, unless: :logged_in?

  def create
    @matter = Matter.active.find(params[:matter_id])
    return response_forbidden unless correct_user
    @charge = current_user.charges.new(matter_id: @matter.id)
    if @charge.save
      render json: { status: 200, message: "ピン止めしました"}
    else
      render json: { status: 400, message: 'ピン止め出来ません。入力必須項目を確認してください', errors: @charge.errors }
    end
  end

  def destroy
    @matter = Matter.active.find(params[:matter_id])
    @charge = Charge.find(params[:id])
    return response_forbidden unless correct_user
    @charge.destroy
    render json: { status: 200, message: "ピン止めを解除しました"}
  end

  private

  def correct_user
    if action_name == 'create'
      return true if @matter.join_check(current_user) || @matter.client.join_check(current_user)
    elsif action_name
      if @matter.join_check(current_user) || @matter.client.join_check(current_user)
        return true if @charge.user == current_user
      end
    end
  end
end