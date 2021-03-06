class AgendasController < ApplicationController
  before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: 'アジェンダ作成に成功しました！'
    else
      render :new
    end
  end

  def destroy
    if check_auth_destoy?
      @agenda.destroy 
      @working_team.members.each do |member|
        AgendaMailer.agenda_mail(member.email , @working_team.name, @agenda.title).deliver
      end
      redirect_to dashboard_url, notice: 'アジェンダ削除に成功しました！'
    else
      redirect_to dashboard_url, notice: 'アジェンダを削除する権限がありません'
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end

  def check_auth_destoy?
    if current_user.id == @agenda.user_id || current_user.id == @working_team.owner_id 
      true
    else
      false
    end
  end
end
