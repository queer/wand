use Mahou.Config

[
  %App{
    name: "test",
    image: "nginx",
    limits: %Limits{
      cpu: 1,
      ram: 16,
    }
  },
  %App{
    name: "test",
    namespace: "banana",
    image: "nginx",
    limits: %Limits{
      cpu: 1,
      ram: 16,
    }
  },
]
