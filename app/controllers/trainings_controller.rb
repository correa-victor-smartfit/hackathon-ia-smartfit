class TrainingsController < ApplicationController
  def create
    objetivo = params[:objetivo]           # Exemplo: "ganho de massa muscular"
    nivel = params[:nivel]                 # Exemplo: "iniciante"
    muscle_groups = params[:muscle_groups] # Exemplo: ["triceps", "legs"]

    openai_client = OpenaiClient.new
    treino = openai_client.gerar_treino(objetivo, nivel, muscle_groups)

    render json: { treino: treino }
  end
end
