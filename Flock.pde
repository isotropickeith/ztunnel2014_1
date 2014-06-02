class Flock
{
  ArrayList<Bird> particles; // An ArrayList for all the boids

  Flock()
  {
    particles = new ArrayList<Bird>(); // Initialize the ArrayList
  }
  
  
  ArrayList<Bird> getFlock()
  {
    return particles;
  }

  void run(boolean isFree)
  {
    for (Bird b : particles)
    {
      b.run(particles, isFree);  // Passing the entire list of boids to each boid individually
    }
  }

  void addParticle(Bird b)
  {
    particles.add(b);
  }

}
