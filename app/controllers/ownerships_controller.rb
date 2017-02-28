class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:item_code]
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
    else
      @item = Item.find(params[:item_id])
      current_user.have(@item)
      current_user.want(@item)
    end
  end
  
  def find
    if @item.new_record?
      items = RakutenWebService::Ichiba::Item.search
    else
      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.save!
    end
  end
    
    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
  def edit
    @user = Item.find(params[:item_code])
  end
  
  def have(item)
    @user = Item.find(params[:item_code])
    @users = @user.have_items
  end
  
  def want(item)
    @user = Item.find(params[:item_code])
    @users = @user.want_items
  end

  def destroy
    @item = Item.find(params[:item_id])
    current_user.unhave(@item)
    current_user.unwant(@item)

    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。
  end
end
