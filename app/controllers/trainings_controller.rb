class TrainingsController < ApplicationController
  def create
    objetivo = 'ganho de massa muscular' # params[:objetivo]
    nivel = 'inciante' # params[:nivel]
    days = 4
    muscle_groups = %w[
    abdominal
    biceps
    breastplate
    dorsal
    hit
    legs
    lumbar
    shoulder
    triceps
    ] # params[:muscle_groups]

    openai_client = OpenaiClient.new
    treino = openai_client.gerar_treino(objetivo, nivel, days, muscle_groups)

    if request.format.html?
      render plain: treino
    else
      render json: { treino: treino }
    end
  end
end
