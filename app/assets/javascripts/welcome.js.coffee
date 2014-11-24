# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App = angular.module('myApp', [])

App.controller("GiftItemController", ["$scope", "$http", ($scope, $http) ->

  $scope.wish_lists = {}

  $scope.loadItems = ->
    $http.get("/items.json")
      .success (data) ->
        $scope.items = data
      .error (data) ->
        console.log "data.error"

  $scope.loadWishList = ->
    $http.get("/lists.json")
      .success (data) ->
        $scope.wish_lists = data
      .error (data) ->
        console.log "Wish list error"

  $scope.addItemToWishList = (wishlistId, itemId) ->
    jsonObj = {"data": {"list_id": wishlistId, "item_id": itemId }}

    # Devise requires a CSRF token be included with all requests. The presence of this token
    # guarantees that the current page was meant to make this request.
    # See more: http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')

    $http.post('api/wanted_items/submit.json', jsonObj)
      .success (data) ->
        $scope.loadWishList()
      .error (data) ->
        console.log "data error"

  $scope.addNewWishList = ->
    jsonObj = {"list_name": $scope.newListName}
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')

    $http.post('lists.json', jsonObj)
      .success (data) ->
        $scope.loadWishList()
      .error (data) ->
        console.log "data error"

  $scope.showList = ->
    $http.get("/lists.json")
      .success (data) ->
        container = data[0].wanted_items
        newData = []
        for obj in container
          newData.push obj.item
        $scope.items = newData
        console.log $scope.items
      .error (data) ->
        console.log "Wish list error"

  $scope.loadItems()
  $scope.loadWishList()
])

window.onload = ->

  ###*
  Demo 1: Elements
  ###

  # Event Listener for when the drag interaction starts.

  # Event Listener for when the drag interaction finishes.

  # Event Listener for when the dragged element is over the drop zone.

  # Event Listener for when the dragged element enters the drop zone.

  # Event Listener for when the dragged element leaves the drop zone.

  # Event Listener for when the dragged element dropped in the drop zone.

  # Remove the element from the list.

  ###*
  Demo 2: Text Files
  ###

  # Event Listener for when the dragged file is over the drop zone.

  # Event Listener for when the dragged file enters the drop zone.

  # Event Listener for when the dragged file leaves the drop zone.

  # Event Listener for when the dragged file dropped in the drop zone.

  # Read the contents of a file.

  dropZoneOne = document.querySelector("#drop-target-one")
  dragElements = document.querySelectorAll("#list-drop")
  elementDragged = null
  i = 0

  while i < dragElements.length
    dragElements[i].addEventListener "dragstart", (e) ->
      e.dataTransfer.effectAllowed = "move"
      e.dataTransfer.setData "text", @innerHTML
      elementDragged = this
      return

    dragElements[i].addEventListener "dragend", (e) ->
      elementDragged = null
      return
    i++

  dropZoneOne.addEventListener "dragover", (e) ->
    e.preventDefault()  if e.preventDefault
    e.dataTransfer.dropEffect = "move"
    false

  dropZoneOne.addEventListener "dragenter", (e) ->
    @className = "over"
    return

  dropZoneOne.addEventListener "dragleave", (e) ->
    @className = ""
    return

  dropZoneOne.addEventListener "drop", (e) ->
    e.preventDefault()  if e.preventDefault
    e.stopPropagation()  if e.stopPropagation
    @className = ""
    elementDragged = null
    console.log "Dropped!"
    $.post(
      )
    false

  return
