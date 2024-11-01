
class TrainingsController < ApplicationController
  def create
    objetivo = params[:objetivo]  # Exemplo: "ganho de massa muscular"
    nivel = params[:nivel]        # Exemplo: "iniciante"

    openai_client = OpenAIClient.new
    treino = openai_client.gerar_treino(objetivo, nivel)

    render json: { treino: treino }
  end
end
