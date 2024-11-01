require 'csv'
require 'gruff'

csv_file = "resultados.csv"
tempos = {}

CSV.foreach(csv_file, headers: true) do |row|
  algoritmo = row['Algoritmo']
  tamanho = row['Tamanho da Amostra'].to_i
  tempo = row['Tempo (s)'].to_f
  tempos[algoritmo] ||= []
  tempos[algoritmo] << [tamanho, tempo]
end

g = Gruff::Line.new
g.title = 'Comparativo de Desempenho dos Algoritmos de Ordenação'
g.x_axis_label = 'Número de Elementos'
g.y_axis_label = 'Tempo de Execução (s)'

tempos.each do |algoritmo, dados|
  dados.sort_by!(&:first)
  tamanhos = dados.map { |d| d[0] }
  tempos_execucao = dados.map { |d| d[1] }
  g.data(algoritmo, tempos_execucao)
end

g.write('./grafico_comparativo.png')
