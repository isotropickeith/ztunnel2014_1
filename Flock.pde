class Flock
{
  ArrayList<Bird> birds; // An ArrayList for all the boids

  Flock()
  {
    birds = new ArrayList<Bird>(); // Initialize the ArrayList
  }
  
  
  ArrayList<Bird> getFlock()
  {
    return birds;
  }

  void run(boolean isFree)
  {
    for (Bird b : birds)
    {
      b.run(birds, isFree);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBird(Bird b)
  {
    birds.add(b);
  }

}
