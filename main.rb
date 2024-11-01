require 'benchmark'
require 'csv'

def bubble_sort(arr)
  (arr.length - 1).times do |j|
    (arr.length - 1 - j).times do |i|
      if arr[i] > arr[i + 1]
        arr[i], arr[i + 1] = arr[i + 1], arr[i]
      end
    end
  end
  arr
end

def quick_sort(arr)
  return arr if arr.length <= 1
  pivot = arr[rand(arr.length)]
  left,rest = arr.partition { |x| x < pivot }
  equal, right = rest.partition{ |x| x == pivot }
  return quick_sort(left) + equal + quick_sort(right)
end

def radix_logic(arr)
  max_digits = arr.map { |num| num.abs.digits.size }.max
  (0...max_digits).each do |digit|
    arr_positions = Array.new(10) { [] }
    arr.each do |number|
      position = (number.abs / 10**digit) % 10
      arr_positions[position].push(number)
    end
    arr = arr_positions.flatten
  end
  arr
end

def radix_sort(arr)
  positive, negative = arr.partition { |x| x >= 0}
  radix_logic(negative).reverse + radix_logic(positive)
end

require_relative './amostras/amostra_10000'
require_relative './amostras/amostra_20000'
require_relative './amostras/amostra_30000'
require_relative './amostras/amostra_40000'
require_relative './amostras/amostra_50000'
require_relative './amostras/amostra_60000'
require_relative './amostras/amostra_70000'
require_relative './amostras/amostra_80000'
require_relative './amostras/amostra_90000'
require_relative './amostras/amostra_100000'

csv_file = "resultados.csv"


CSV.open(csv_file, "wb") do |csv|

  csv << ["Algoritmo", "Tamanho da Amostra", "Tempo (s)"]

  amostras = {
    "amostra_10000" => $amostra_10000,
    "amostra_20000" => $amostra_20000,
    "amostra_30000" => $amostra_30000,
    "amostra_40000" => $amostra_40000,
    "amostra_50000" => $amostra_50000,
    "amostra_60000" => $amostra_60000,
    "amostra_70000" => $amostra_70000,
    "amostra_80000" => $amostra_80000,
    "amostra_90000" => $amostra_90000,
    "amostra_100000" => $amostra_100000
  }

  amostras.each do |nome, array|
    puts "Executando para #{nome} (#{array.size} elementos)"

    threads = []

    threads << Thread.new do
      time = Benchmark.realtime { bubble_sort(array.clone) }
      puts "Bubble Sort levou #{time}"
      csv << ["Bubble Sort", array.size, time]
    end

    threads << Thread.new do
      time = Benchmark.realtime { quick_sort(array.clone) }
      puts "Quick Sort levou #{time}"
      csv << ["Quick Sort", array.size, time]
    end

    threads << Thread.new do
      time = Benchmark.realtime { radix_sort(array.clone) }
      puts "Radix Sort levou #{time}"
      csv << ["Radix Sort", array.size, time]
    end

    threads.each(&:join)
    puts '============================'
  end
end

puts "Resultados salvos em #{csv_file}"
