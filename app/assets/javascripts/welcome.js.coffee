# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App = angular.module('myApp', ['ngRoute', 'templates'])
dropAnimation = () ->
  dropText = document.createElement("i")
  dropText.id = "animated-text"
  dropText.innerHTML = ""
  if $('#animated-text').length < 1
    $('#drop-target-one').append(dropText)
  $('#animated-text').addClass("fa fa-gift").addClass("animated zoomOutDown")
  setTimeout ( ->
    $('#animated-text').remove()), 1000

removeAnimation = (wanted_item_id) ->
  $('#item-' + wanted_item_id).addClass("animated zoomOutLeft")


# Setup AngularJS Routes
App.config([ '$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider
    .when('/',
      templateUrl: "catalogue.html"
    ).when('/wishlist/:id',
      templateUrl: "wish_list_details.html",
      controller: 'WishListController'
    ).when('/my_wish_list',
      templateUrl: "my_wish_list.html",
      controller: 'MyWishListController'
    )

  $locationProvider.html5Mode(true);
])

# ng-controller for My Wish Lists
App.controller("MyWishListController", ["$scope", "$http", "$routeParams", ($scope, $http, $routeParams) ->

  $scope.wanted_item = {}

  $scope.getCurrentUser = () ->
    $http.get("/api/currentUser.json")
      .success (data) ->
        $scope.current_user = data
        $scope.wanted_item = $scope.current_user['wanted_items'][0]
        $scope.getMyList()
        $scope.retrieveContribution()
        $scope.retrieveComments()
      .error (data) ->
        console.log " current user error"

  $scope.changeWantedItem = (wanted_item_id) ->
    $http.get("/api/wanted_items/#{wanted_item_id}.json")
      .success (data) ->
        $scope.wanted_item = data
        $scope.retrieveContribution()
        $scope.retrieveComments()
      .error (data) ->
        console.log " get wanted item error"

  $scope.adjustPriority = (priority, wanted_item_id) ->
    jsonObj = { priority: priority }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    $http.post("/api/wanted_items/#{wanted_item_id}/updatePriority.json", jsonObj)
      .success (data) ->
        $scope.getMyList()
        console.log "updated priority"
      .error (data) ->
        console.log "update priority error"

  $scope.getMyList = () ->
    $http.get("/api/lists/#{$scope.current_user.lists[0].id}/getMyList.json")
      .success (data) ->
        $scope.myList = data
      .error (data) ->
        console.log " get user error"


  # retrieveContribution retrieves the array of contributors and the amount
  $scope.retrieveContribution = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/contributionData.json")
      .success (data) ->
        $scope.contributors = data   # Array of contributors and amount
        $scope.showTotalContribution()
      .error (data) ->
        console.log "contribution retrieve error"

  # calculates the latest total contribution
  $scope.showTotalContribution = ->
    $scope.totalContribution = 0
    for contribution in $scope.contributors
      $scope.totalContribution += contribution.amount
    $scope.remainingContribution = $scope.wanted_item.item.price - $scope.totalContribution
    $scope.remainingPercentage = Math.floor(($scope.totalContribution / $scope.wanted_item.item.price ) * 100)


  $scope.postComment = (comment) ->
    jsonObj = { content: comment, wanted_item_id: $scope.wanted_item.id }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    $http.post("/api/comments.json", jsonObj)
      .success (data) ->
        console.log "comment posted"
        $scope.comment = ""
        $scope.retrieveComments()
      .error (data) ->
        console.log "contribution error"

  $scope.retrieveComments = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/commentData.json")
      .success (data) ->
        $scope.comments = data
      .error (data) ->
        console.log "comments retrieve error"


  $scope.$on( "reloadList", ->
    $scope.getMyList()
  )

  $scope.getCurrentUser()

  ])


# ng-controller for Wish Lists
App.controller("WishListController", ["$scope", "$http", "$routeParams", ($scope, $http, $routeParams) ->

  $scope.wanted_item = {}

  $scope.getCurrentUser = () ->
    $http.get("/api/currentUser.json")
      .success (data) ->
        $scope.current_user = data
      .error (data) ->
        console.log " current user error"

  $scope.getList = () ->
    $http.get("/api/lists/#{$routeParams['id']}.json")
      .success (data) ->
        $scope.user = data
        $scope.friend_wanted_items = $scope.user.wanted_items
        $scope.wanted_item = $scope.friend_wanted_items[0]
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

  # makeContribution
  $scope.makeContribution = ->
    jsonObj = { amount: $scope.contribution.amount, wanted_item_id: $scope.wanted_item.id }
    console.log jsonObj
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    $http.post("/api/contributions.json", jsonObj)
      .success (data) ->
        $scope.contribution.amount = ""
        $scope.retrieveContribution()
      .error (data) ->
        console.log "contribution error"

  #completeContribution
  $scope.completeContribution = ->
    jsonObj = { amount: (Math.round($scope.remainingContribution * 100) / 100), wanted_item_id: $scope.wanted_item.id }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    $http.post("/api/contributions.json", jsonObj)
      .success (data) ->
        console.log "Completed contribution!"
        $scope.retrieveContribution()
      .error (data) ->
        console.log "contribution error"


  # retrieveContribution retrieves the array of contributors and the amount
  $scope.retrieveContribution = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/contributionData.json")
      .success (data) ->
        console.log data
        $scope.contributors = data   # Array of contributors and amount
        $scope.showTotalContribution()
      .error (data) ->
        console.log "contribution retrieve error"

  # calculates the latest total contribution
  $scope.showTotalContribution = ->
    $scope.totalContribution = 0
    for contribution in $scope.contributors
      $scope.totalContribution += contribution.amount
    $scope.remainingContribution = $scope.wanted_item.item.price - $scope.totalContribution
    $scope.remainingPercentage = Math.floor(($scope.totalContribution / $scope.wanted_item.item.price ) * 100)


  $scope.postComment = (comment) ->
    jsonObj = { content: comment, wanted_item_id: $scope.wanted_item.id }
    jsonObj[$('meta[name=csrf-param]').attr('content')] = $('meta[name=csrf-token]').attr('content')
    $http.post("/api/comments.json", jsonObj)
      .success (data) ->
        console.log "comment posted"
        $scope.comment = ""
        $scope.retrieveComments()
      .error (data) ->
        console.log "contribution error"

  $scope.retrieveComments = ->
    $http.get("api/wanted_items/#{$scope.wanted_item.id}/commentData.json")
      .success (data) ->
        $scope.comments = data
      .error (data) ->
        console.log "comments retrieve error"


  $scope.getList()
  $scope.getCurrentUser()

  ])


# ng-controller for Catalogue
App.controller("GiftItemController", ["$scope", "$http", "$timeout", ($scope, $http, $timeout) ->

  $scope.wish_lists = []

  $scope.loadItems = ->
    $http.get("/api/items.json")
      .success (data) ->
        console.log 'i am done loading the items'
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

  $scope.removeItemFromWishList = (wanted_item_id) ->
    $http.delete("api/wanted_items/#{wanted_item_id}.json")
      .success (data) ->
        console.log "Item destroyed"
        $scope.$broadcast("reloadList")
        removeAnimation(wanted_item_id)
        $timeout($scope.loadWishList, 1000)

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
    console.log 'i am setting up bindings for anything that might get dragged'
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
      dropAnimation()
      false

    return

  $scope.loadFriends = ->
    $http.get("/api/friends.json")
      .success (data) ->
        $scope.friends = data
        setTimeout($scope.reactiveSearchBarWidth, 0)
      .error (data) ->
        console.log "friends data error"

  $scope.reactiveSearchBarWidth = ->
    $('.friends-search input.search-bar').css('width', $('div.friend-container').css('width'))
    $('.friend-search .bar').css('width', $('div.friend-container').css('width'))

    $('.catalogue-search input.search-bar').css('width', $('li#tasty-search-bar').css('width'))
    $('.catalogue-search .bar').css('width', $('li#tasty-search-bar').css('width'))

  $(window).resize( $scope.reactiveSearchBarWidth )

  $scope.loadItems()
  $scope.loadWishList()
  $scope.loadFriends()
])



