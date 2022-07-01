matter_category_parent_array = %i[
  離婚・男女問題 刑事事件 交通事故 労働関連 遺言・遺産相続
  建築・不動産 ネット上のトラブル 債務整理 破産・民事再生
  債権回収 税務・行政事件 医療問題 国際問題 知的財産 企業法務
  顧問 その他案件
]

matter_category_child_array = [
  # 離婚・男女問題
  %i[離婚 財産分与 年金分割  養育費  慰謝料  不倫  その他男女問題 ],
  # 刑事事件 
  %i[],
  # 交通事故 
  %i[],
  # 労働関連 
  %i[],
  # 遺言・遺産相続
  %i[],
  # 建築・不動産 
  %i[],
  # ネット上のトラブル 
  %i[],
  # 債務整理 
  %i[],
  # 破産・民事再生
  %i[],
  # 債権回収 
  %i[ ],
  #税務・行政事件 
  %i[],
  # 医療問題 
  %i[],
  # 国際問題 
  %i[],
  # 知的財産 
  %i[],
  # 企業法務
  %i[],
  # 顧問 
  %i[],
  # その他案件
  %i[],
]

# matter_category
matter_category_parent_array.each_with_index do |parent, i|
  matter_category_parent = MatterCategory.create(name: parent)
  matter_category_child_array[i].each do |child|
    matter_category_parent.children.create(name: child)
  end
end

# matter_category_children
# matter_category_parents = MatterCategory.where(ancestry: nil)

# matter_category_parents.each_with_index do |parent, c|
#   matter_category_child_array[c].each do |child|
#     parent.children.create(name: child)
#   end
# end
