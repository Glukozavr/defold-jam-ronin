components {
  id: "shadow"
  component: "/game/characters/shadow.script"
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "physical_body"
  type: "collisionobject"
  data: "collision_shape: \"\"\n"
  "type: COLLISION_OBJECT_TYPE_KINEMATIC\n"
  "mass: 0.0\n"
  "friction: 0.1\n"
  "restitution: 0.5\n"
  "group: \"mob\"\n"
  "mask: \"ground\"\n"
  "mask: \"player\"\n"
  "embedded_collision_shape {\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "      x: -1.0\n"
  "      y: -17.0\n"
  "      z: 0.0\n"
  "    }\n"
  "    rotation {\n"
  "      x: 2.090056E-4\n"
  "      y: 0.016421141\n"
  "      z: 0.012725089\n"
  "      w: 0.9997842\n"
  "    }\n"
  "    index: 0\n"
  "    count: 1\n"
  "  }\n"
  "  shapes {\n"
  "    shape_type: TYPE_SPHERE\n"
  "    position {\n"
  "      x: -1.0\n"
  "      y: -1.0\n"
  "      z: 0.0\n"
  "    }\n"
  "    rotation {\n"
  "      x: 0.0\n"
  "      y: 0.0\n"
  "      z: 0.0\n"
  "      w: 1.0\n"
  "    }\n"
  "    index: 1\n"
  "    count: 1\n"
  "  }\n"
  "  data: 10.4075\n"
  "  data: 5.7645\n"
  "}\n"
  "linear_damping: 0.0\n"
  "angular_damping: 0.0\n"
  "locked_rotation: false\n"
  "bullet: false\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "tile_set: \"/assets/images/characters/shadow/shadow.tilesource\"\n"
  "default_animation: \"idle\"\n"
  "material: \"/builtins/materials/sprite.material\"\n"
  "blend_mode: BLEND_MODE_ALPHA\n"
  "playback_rate: 0.5\n"
  ""
  position {
    x: 0.0
    y: 0.0
    z: 0.0
  }
  rotation {
    x: 0.0
    y: 0.0
    z: 0.0
    w: 1.0
  }
}
