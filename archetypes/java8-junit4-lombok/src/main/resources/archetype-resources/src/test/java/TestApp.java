package ${package};

import static org.junit.Assert.assertEquals;

import lombok.extern.slf4j.Slf4j;
import org.junit.Test;

@Slf4j
public class TestApp {

  @Test
  public void testApp() {
    log.info("Running test");
    boolean ret = true;

    assertEquals(ret, true);
  }
}
