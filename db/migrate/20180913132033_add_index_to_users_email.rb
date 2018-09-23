class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  #usersテーブルのemailカラムにインデックスを追加するためにadd_indexというRailsのメソッドを使っています。インデックス自体は一意性を強制しませんが、オプションでunique: trueを指定することで強制できるようになります。
  def change
    add_index :users, :email, unique: true
  end
end
