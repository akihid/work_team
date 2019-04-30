class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit; end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      redirect_to @team, notice: 'チーム作成に成功しました！'
    else
      flash.now[:error] = '保存に失敗しました、、'
      render :new
    end
  end

  def update
    if params[:user_id]
      authority_transfer
    else
      if @team.update(team_params)
        redirect_to @team, notice: 'チーム更新に成功しました！'
      else
        flash.now[:error] = '保存に失敗しました、、'
        render :edit
      end
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: 'チーム削除に成功しました！'
  end

  def dashboard
    @team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : current_user.teams.first
  end

  private

  def set_team
    @team = Team.friendly.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

  def authority_transfer
    @team.owner_id = params[:user_id]
    @email = params[:user_email]
    if @team.update(team_params)
      redirect_to @team, notice: '権限移動に成功しました！'
      TransferMailer.transfer_mail(@email , @team.name).deliver
    else
      flash.now[:error] = '権限移動に失敗しました、、'
      render :edit
    end
  end
end
