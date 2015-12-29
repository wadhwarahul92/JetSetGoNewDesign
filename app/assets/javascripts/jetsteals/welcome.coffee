$(document).on('ready page:load', ->
  scene = document.getElementById('scene')
  if scene
    new Parallax(scene)
)