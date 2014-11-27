# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App = angular.module('myApp', ['ngRoute', 'templates'])
dropAnimation = () ->
  dropText = document.createElement("span")
  dropText.id = "animated-text"
  dropText.innerHTML = "Item Added!"
  if $('#animated-text').length < 1
    $('#drop-target-one').append(dropText)
  $('#animated-text').addClass("animated fadeOutUp")
  setTimeout ( -> 
    $('#animated-text').remove()), 1000


# Setup AngularJS Routes
App.config([ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/',
      templateUrl: "catalogue.html",
      controller: 'GiftItemController'
    ).when('/wishlist/:id',
      templateUrl: "wish_list_details.html",
      controller: 'WishListController'
    )

  $locationProvider.html5Mode(true);
])

# ng-controller for Wish Lists
App.controller("WishListController", ["$scope", "$http", "$routeParams", ($scope, $http, routeParams) ->

  $scope.wanted_item = {}

  $scope.getList = () ->
    $http.get("/api/lists/#{routeParams['id']}.json")
      .success (data) ->
        $scope.user = data
        $scope.wanted_item = $scope.user['wanted_items'][0]
        $scope.retrieveContribution()
        $scope.retrieveComments()
      .error (data) ->
        console.log " get user error"

  $scope.changeWantedItem = (wanted_item_id) ->
    $http.get("/api/wanted_items/#{wanted_item_id}.json")
      .success (data) ->
        $scope.wanted_item = data
        $scope.retrieveContribution()
        $scope.retrieveComments()
      .error (data) ->
        console.log " get wanted item error"

  $scope.postComment = ->
    jsonObj = routeParams['comment']
    console.log jsonObj

  $scope.makeContribution = ->
    # console.log $scope.contribution
    jsonObj = { amount: $scope.contribution.amount, wanted_item_id: $scope.wanted_item.id }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    console.log jsonObj
    $http.post("/api/contributions.json", jsonObj)
      .success (data) ->
        $scope.retrieveContribution()
        $scope.contribution.amount = ""
      .error (data) ->
        console.log "contribution error"

  $scope.retrieveContribution = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/contributionData.json")
      .success (data) ->
        $scope.contributors = data
        console.log $scope.contributors
        $scope.showTotalContribution()
        $scope.calculateRemaining()
        $scope.calculateRemainingPercentage()
      .error (data) ->
        console.log "contribution retrieve error"

  $scope.showTotalContribution = ->
    $scope.totalContribution = 0
    for contribution in $scope.contributors
      $scope.totalContribution += contribution.amount
    $scope.totalContribution

  $scope.calculateRemaining = ->
    $scope.remainingContribution = $scope.wanted_item.item.price - $scope.totalContribution

  $scope.calculateRemainingPercentage = ->
    $scope.remainingPercentage = Math.floor(($scope.totalContribution / $scope.wanted_item.item.price ) * 100)

  $scope.postComment = (comment) ->
    jsonObj = { content: comment, wanted_item_id: $scope.wanted_item.id }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    console.log jsonObj
    $http.post("/api/comments.json", jsonObj)
      .success (data) ->
        console.log "comment posted"
        $scope.retrieveComments()
      .error (data) ->
        console.log "contribution error"

  $scope.retrieveComments = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/commentData.json")
      .success (data) ->
        $scope.comments = data
        console.log data
      .error (data) ->
        console.log "comments retrieve error"


  $scope.getList()

  ])


# ng-controller for Catalogue
App.controller("GiftItemController", ["$scope", "$http", ($scope, $http) ->

  $scope.wish_lists = {}

  $scope.loadItems = ->
    $http.get("/api/items.json")
      .success (data) ->
        $scope.items = data
      .error (data) ->
        console.log "data.error"

  $scope.loadWishList = ->
    $http.get("/api/lists.json")
      .success (data) ->
        $scope.wish_lists = data[0].wanted_items
      .error (data) ->
        console.log "Wish list error"

  $scope.addItemToWishList = (itemId) ->
    jsonObj = { "item_id": itemId }

    # Devise requires a CSRF token be included with all requests. The presence of this token
    # guarantees that the current page was meant to make this request.
    # See more: http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')

    $http.post('api/wanted_items/submit.json', jsonObj)
      .success (data) ->
        $scope.loadWishList()
      .error (data) ->
        console.log "data error"

  $scope.removeItemFromWishList = (itemId) ->
    jsonObj = { "item_id": itemId }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')

    $http.post('api/wanted_items/destroy.json', jsonObj)
      .success (data) ->
        $scope.loadWishList()
      .error (data) ->
        console.log "data error"

  # $scope.addNewWishList = ->
  #   jsonObj = {"list_name": $scope.newListName}
  #   jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')

  #   $http.post('lists.json', jsonObj)
  #     .success (data) ->
  #       $scope.loadWishList()
  #     .error (data) ->
  #       console.log "data error"

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

  $scope.dragdrop = ->
    dropZoneOne = document.querySelector("#drop-target-one")
    dragElements = document.querySelectorAll(".list-drop")
    elementDragged = null
    i = 0

    while i < dragElements.length
      dragElements[i].addEventListener "dragstart", (e) ->
        e.dataTransfer.effectAllowed = "move"
        e.dataTransfer.setData "text", @innerHTML
        elementDragged = this
        $scope.selectedItem = $(@).data("item")
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
      $scope.addItemToWishList($scope.selectedItem)
      elementDragged = null
      $scope.loadWishList()
      dropAnimation()
      false

    return

  $scope.loadFriends = ->
    $http.get("/api/friends.json")
      .success (data) ->
        $scope.friends = data
      .error (data) ->
        console.log "friends data error"


  $scope.loadItems()
  $scope.loadWishList()
  $scope.loadFriends()
])

