# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App = angular.module('myApp', ['ngRoute', 'templates'])

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

  $scope.user_id = routeParams['id']

  $scope.getList = () ->
    $http.get("/api/lists/#{$scope.user_id}.json")
      .success (data) ->
        console.log data
        $scope.user = data
      .error (data) ->
        console.log " get user error"

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

