
namespace Symfony\Component\Stopwatch;

class Stopwatch
{
    /**
     * @var Section[]
     */
    protected sections;
    /**
     * @var Section[]
     */
    protected activeSections;
    public function __construct() -> void
    {
        let this->sections = ["__root__" : new Section("__root__")];
        let this->activeSections = ["__root__" : new Section("__root__")];
        ;
    }
    
    /**
     * @return Section[]
     */
    public function getSections() -> array
    {
        return this->sections;
    }
    
    /**
     * Creates a new section or re-opens an existing section.
     *
     * @param string|null $id The id of the session to re-open, null to create a new one
     *
     * @throws \LogicException When the section to re-open is not reachable
     */
    public function openSection(id = null) -> void
    {
        var current;
    
        let current =  end(this->activeSections);
        if id !== null && current->get(id) === null {
            throw new \LogicException(sprintf("The section \"%s\" has been started at an other level and can not be opened.", id));
        }
        this->start("__section__.child", "section");
        let this->activeSections[] =  current->open(id);
        this->start("__section__");
    }
    
    /**
     * Stops the last started section.
     *
     * The id parameter is used to retrieve the events from this section.
     *
     * @see getSectionEvents()
     *
     * @param string $id The identifier of the section
     *
     * @throws \LogicException When there's no started section to be stopped
     */
    public function stopSection(string id) -> void
    {
        this->stop("__section__");
        if 1 == count(this->activeSections) {
            throw new \LogicException("There is no started section to stop.");
        }
        let this->sections[id] =  array_pop(this->activeSections)->setId(id);
        this->stop("__section__.child");
    }
    
    /**
     * Starts an event.
     *
     * @param string $name     The event name
     * @param string $category The event category
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function start(string name, string category = null) -> <StopwatchEvent>
    {
        return end(this->activeSections)->startEvent(name, category);
    }
    
    /**
     * Checks if the event was started.
     *
     * @param string $name The event name
     *
     * @return bool
     */
    public function isStarted(string name) -> bool
    {
        return end(this->activeSections)->isEventStarted(name);
    }
    
    /**
     * Stops an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function stop(string name) -> <StopwatchEvent>
    {
        return end(this->activeSections)->stopEvent(name);
    }
    
    /**
     * Stops then restarts an event.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function lap(string name) -> <StopwatchEvent>
    {
        return end(this->activeSections)->stopEvent(name)->start();
    }
    
    /**
     * Returns a specific event by name.
     *
     * @param string $name The event name
     *
     * @return StopwatchEvent A StopwatchEvent instance
     */
    public function getEvent(string name) -> <StopwatchEvent>
    {
        return end(this->activeSections)->getEvent(name);
    }
    
    /**
     * Gets all events for a given section.
     *
     * @param string $id A section identifier
     *
     * @return StopwatchEvent[] An array of StopwatchEvent instances
     */
    public function getSectionEvents(string id) -> array
    {
        var temp = [];
        return  isset this->sections[id] ? this->sections[id]->getEvents()  : temp;
    }

}