class FriendshipsController < ApplicationController
  # GET /friendships
  # GET /friendships.json
  def index
    @friendships = Friendship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @friendships }
    end
  end

  # GET /friendships/1
  # GET /friendships/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: current_user.friendships.friend}
    end
  end

  # GET /friendships/new
  # GET /friendships/new.json
  def new
    @friendship = Friendship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @friendship }
    end
  end

  # GET /friendships/1/edit
  def edit
    @friendship = Friendship.find(params[:id])
  end

  # POST /friendships
  # POST /friendships.json
  def create
    friend=User.find_by_email(params[:email])
    @friendship = current_user.friendships.build(:friend_id => friend.id)

    respond_to do |format|
      if @friendship.save
        @friendship=friend.friendships.build(:friend_id => current_user.id)
        if @friendship.save
          format.html { redirect_to @friendship, notice: 'Friendship was successfully created.' }
          format.json { render json: {:created => 'True'}}
        else
          format.html { render action: "new" }
          format.json { render json: {:created => 'False'}}
        end
      else
        format.html { render action: "new" }
        format.json { render json: {:created => 'False'}}
      end
    end
  end

  # PUT /friendships/1
  # PUT /friendships/1.json
  def update
    @friendship = Friendship.find(params[:id])

    respond_to do |format|
      if @friendship.update_attributes(params[:friendship])
        format.html { redirect_to @friendship, notice: 'Friendship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friendships/1
  # DELETE /friendships/1.json
  def destroy
    friend=User.find_by_email(params[:email])
    @friendship = current_user.friendships.find(friend.id)
    @friendship.destroy
    @friendship = friend.friendships.find(current_user.id)
    @friendship.destroy

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: {:deleted => 'True'}}
    end
  end
end
