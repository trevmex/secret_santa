class EventsController < ApplicationController
  # GET /events
  # GET /events.json
  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @participants = Participant.all
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        add_participants_to_event(params[:participants])
        assign_gift_givers(@event)
        
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        add_participants_to_event(params[:participants])
        assign_gift_givers(@event.participants)
        
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    remove_participants_from_event(@event.participants)
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :ok }
    end
  end
  
  private
  
  def add_participants_to_event(participant_ids)
    participant_ids.each do |participant_id|
      participant = Participant.find(participant_id)
      participant.update_attributes(:event_id => @event.id) unless participant.blank?
    end unless participant_ids.blank?
  end

  def remove_participants_from_event(participants)
    participants.each do |participant|
      participant.update_attributes(:event_id => nil) unless participant.blank?
    end unless participants.blank?
  end
  
  def assign_gift_givers(participants)
    participant_ids = participants.map {|p| p.id}
    participants.each do |participant|
      usable_participant_ids = participant_ids.reject {|pid| pid == participant.id}
      gift_giver = usable_participant_ids.shuffle.pop
      participant.update_attributes({:participant_id => gift_giver})
      participant_ids.delete_if {|pid| pid == gift_giver}
    end
  end
end
