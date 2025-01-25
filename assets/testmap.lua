return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.11.1",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 16,
  height = 16,
  tilewidth = 16,
  tileheight = 16,
  nextlayerid = 7,
  nextobjectid = 28,
  properties = {},
  tilesets = {
    {
      name = "water",
      firstgid = 1,
      class = "",
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      columns = 12,
      image = "Water+.png",
      imagewidth = 192,
      imageheight = 240,
      objectalignment = "unspecified",
      tilerendersize = "tile",
      fillmode = "stretch",
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 16,
        height = 16
      },
      properties = {},
      wangsets = {
        {
          name = "pipes",
          class = "",
          tile = -1,
          wangsettype = "mixed",
          properties = {},
          colors = {
            {
              color = { 255, 0, 0 },
              name = "",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            }
          },
          wangtiles = {
            {
              wangid = { 0, 0, 1, 0, 0, 0, 0, 0 },
              tileid = 120
            },
            {
              wangid = { 0, 0, 1, 0, 0, 0, 1, 0 },
              tileid = 121
            },
            {
              wangid = { 0, 0, 1, 0, 1, 0, 1, 0 },
              tileid = 122
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 1, 0 },
              tileid = 123
            },
            {
              wangid = { 0, 0, 0, 0, 1, 0, 0, 0 },
              tileid = 124
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 1, 0 },
              tileid = 125
            },
            {
              wangid = { 0, 0, 1, 0, 0, 0, 0, 0 },
              tileid = 132
            },
            {
              wangid = { 0, 0, 0, 0, 1, 0, 1, 0 },
              tileid = 133
            },
            {
              wangid = { 1, 0, 0, 0, 1, 0, 0, 0 },
              tileid = 134
            },
            {
              wangid = { 0, 0, 1, 0, 1, 0, 0, 0 },
              tileid = 135
            },
            {
              wangid = { 1, 0, 1, 0, 1, 0, 1, 0 },
              tileid = 136
            },
            {
              wangid = { 0, 0, 0, 0, 0, 0, 1, 0 },
              tileid = 137
            },
            {
              wangid = { 1, 0, 1, 0, 0, 0, 0, 0 },
              tileid = 145
            },
            {
              wangid = { 1, 0, 1, 0, 0, 0, 1, 0 },
              tileid = 146
            },
            {
              wangid = { 1, 0, 0, 0, 0, 0, 1, 0 },
              tileid = 147
            },
            {
              wangid = { 1, 0, 0, 0, 0, 0, 0, 0 },
              tileid = 148
            }
          }
        },
        {
          name = "water",
          class = "",
          tile = -1,
          wangsettype = "edge",
          properties = {},
          colors = {
            {
              color = { 255, 0, 0 },
              name = "",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            }
          },
          wangtiles = {
            {
              wangid = { 1, 0, 1, 0, 1, 0, 1, 0 },
              tileid = 9
            },
            {
              wangid = { 1, 0, 1, 0, 1, 0, 1, 0 },
              tileid = 10
            },
            {
              wangid = { 1, 0, 1, 0, 1, 0, 1, 0 },
              tileid = 11
            }
          }
        },
        {
          name = "Unnamed Set",
          class = "",
          tile = -1,
          wangsettype = "mixed",
          properties = {},
          colors = {
            {
              color = { 255, 0, 0 },
              name = "",
              class = "",
              probability = 1,
              tile = -1,
              properties = {}
            }
          },
          wangtiles = {}
        }
      },
      tilecount = 180,
      tiles = {
        {
          id = 2,
          animation = {
            {
              tileid = 4,
              duration = 100
            },
            {
              tileid = 2,
              duration = 100
            },
            {
              tileid = 3,
              duration = 100
            }
          }
        },
        {
          id = 5,
          animation = {
            {
              tileid = 5,
              duration = 800
            },
            {
              tileid = 6,
              duration = 800
            }
          }
        },
        {
          id = 9,
          animation = {
            {
              tileid = 9,
              duration = 600
            },
            {
              tileid = 10,
              duration = 600
            },
            {
              tileid = 11,
              duration = 600
            }
          }
        },
        {
          id = 39,
          animation = {
            {
              tileid = 51,
              duration = 200
            },
            {
              tileid = 39,
              duration = 200
            },
            {
              tileid = 63,
              duration = 200
            }
          }
        },
        {
          id = 43,
          animation = {
            {
              tileid = 43,
              duration = 200
            },
            {
              tileid = 55,
              duration = 200
            },
            {
              tileid = 67,
              duration = 200
            }
          }
        },
        {
          id = 56,
          animation = {
            {
              tileid = 56,
              duration = 200
            },
            {
              tileid = 55,
              duration = 100
            },
            {
              tileid = 68,
              duration = 200
            }
          }
        },
        {
          id = 122,
          animation = {
            {
              tileid = 9,
              duration = 800
            },
            {
              tileid = 10,
              duration = 800
            },
            {
              tileid = 11,
              duration = 800
            }
          }
        },
        {
          id = 156,
          animation = {
            {
              tileid = 156,
              duration = 150
            },
            {
              tileid = 159,
              duration = 150
            },
            {
              tileid = 157,
              duration = 150
            }
          }
        },
        {
          id = 157,
          animation = {
            {
              tileid = 157,
              duration = 100
            },
            {
              tileid = 156,
              duration = 100
            }
          }
        },
        {
          id = 160,
          animation = {
            {
              tileid = 160,
              duration = 100
            },
            {
              tileid = 161,
              duration = 150
            },
            {
              tileid = 162,
              duration = 100
            },
            {
              tileid = 163,
              duration = 100
            }
          }
        },
        {
          id = 173,
          animation = {
            {
              tileid = 173,
              duration = 80
            },
            {
              tileid = 174,
              duration = 80
            },
            {
              tileid = 175,
              duration = 120
            },
            {
              tileid = 176,
              duration = 120
            },
            {
              tileid = 177,
              duration = 120
            },
            {
              tileid = 178,
              duration = 120
            },
            {
              tileid = 179,
              duration = 120
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      id = 1,
      name = "Tile Layer 1",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJzjYmBg4AZiHiDmogCTawYPDjO4ybSXWH2DxQyYPm4c5pBqBg+a3cS4Az3caWEGKfqoZQax4UmOHlLcgC8M8aV/YtxAqd8BzvAKaA=="
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 16,
      height = 16,
      id = 3,
      name = "Tile Layer 2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "base64",
      compression = "zlib",
      data = "eJzNkjEOwjAMRSMhMTByAKAbAxfgaE2BrSllDOG+2NK3+LJS6NABS0+xEn87dhLCf1krRMdjhu4uJKysNUtftNeJfLGy73NtF+AgNPB3wh7+Gqh/BOqfhDPpG+SYq1+BJe7uZ/YURszO3kPjNlgzzpXitAXrCK3Fsj7Q/oX0GTULnd+EoXLflmqo9UIXPn8mQWdx3Iv9xRdifP1IM+jgWy/cb4+YKcukHSrnv/S1PN60hzdbLzFw"
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 5,
      name = "mytest",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 12,
          name = "",
          type = "",
          shape = "rectangle",
          x = 208,
          y = 48,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "",
          shape = "rectangle",
          x = 192,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "",
          shape = "rectangle",
          x = 112,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "",
          type = "",
          shape = "rectangle",
          x = 48,
          y = 32,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 18,
          name = "",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 174,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 174,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "",
          type = "",
          shape = "rectangle",
          x = 32,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 174,
          visible = true,
          properties = {}
        },
        {
          id = 21,
          name = "",
          type = "",
          shape = "rectangle",
          x = 16,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 174,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 157,
          visible = true,
          properties = {}
        },
        {
          id = 26,
          name = "",
          type = "",
          shape = "rectangle",
          x = 80,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 161,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
