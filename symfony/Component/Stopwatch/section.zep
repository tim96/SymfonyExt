
namespace Symfony\Component\Stopwatch;

class Section
{
    /**
     * @var StopwatchEvent[]
     */
    protected events = [];

    /**
     * @var null|float
     */
    protected origin;

    /**
     * @var string
     */
    protected id;

    /**
     * @var Section[]
     */
    protected children = [];

    /**
     * Constructor.
     *
     * @param float|null $origin Set the origin of the events in this section, use null to set their origin to their start time
     */
    public function __construct(origin = null)
    {
        let this->origin =  is_numeric(origin) ? origin  : null;
    }
    
    /**
     * Returns the child section.
     *
     * @param string $id The child section identifier
     *
     * @return Section|null The child section or null when none found
     */
    public function get(string id)
    {
        var child;
    
        for child in this->children {
            if id === child->getId() {
                return child;
            }
        }
    }
    
    /**
     * Creates or re-opens a child section.
     *
     * @param string|null $id null to create a new section, the identifier to re-open an existing one.
     *
     * @return Section A child section
     */
    public function open(id) -> <Section>
    {
        var session;
    
        let session =  this->get(id);
        if session === null {
            let session = new self(microtime(true) * 1000);
            let this->children[] = new self(microtime(true) * 1000);
            ;
        }
        return session;
    }
    
    /**
     * @return string The identifier of the section
     */
    public function getId() -> string
    {
        return this->id;
    }
    
    /**
     * Sets the session identifier.
     *
     * @param string $id The session identifier
     *
     * @return Section The current section
     */
    public function setId(string id) -> <Section>
    {
        let this->id = id;
        return this;
    }
    
    /**
     * Starts an event.
     *
     * @param string $name     The event name
     * @param string $category The event category
     *
     * @return StopwatchEvent The event
     */
    public function startEvent(string name, string category) -> <StopwatchEvent>
    {
        if !(isset this->events[name]) {
            let this->events[name] = new StopwatchEvent( this->origin ? this->origin : microtime(true) * 1000, category);
        }
        return this->events[name]->start();
    }
    
    /**
     * Checks if the event was started.
     *
     * @param string $name The event name
     *
     * @return bool
     */
    public function isEventStarted(string name) -> bool
    {
        return isset this->events[name] && this->events[name]->isStarted();
    }
    
    /**
     * Stops an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When the event has not been started
     */
    public function stopEvent(string name) -> <StopwatchEvent>
    {
        if !(isset this->events[name]) {
            throw new \LogicException(sprintf("Event \'%s\' is not started.", name));
        }
        return this->events[name]->stop();
    }
    
    /**
     * Stops then restarts an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When the event has not been started
     */
    public function lap(string name) -> <StopwatchEvent>
    {
        return this->stopEvent(name)->start();
    }
    
    /**
     * Returns a specific event by name.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent The event
     *
     * @throws \LogicException When the event is not known
     */
    public function getEvent(string name) -> <StopwatchEvent>
    {
        if !(isset this->events[name]) {
            throw new \LogicException(sprintf("Event \'%s\' is not known.", name));
        }
        return this->events[name];
    }
    
    /**
     * Returns the events from this section.
     *
     * @return StopwatchEvent[] An array of StopwatchEvent instances
     */
    public function getEvents() -> array
    {
        return this->events;
    }

}