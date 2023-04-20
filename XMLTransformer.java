import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.*;
import java.io.*;

public class XMLTransformer {

    public static void main(String[] args) {
        String curDirectory = System.getProperty("user.dir");

        if (args.length == 0) {
            System.out.println("Please provide directory name as argument");
            return;
        }
        String directoryName = curDirectory + args[0];
        File directory = new File(directoryName);
        if (!directory.isDirectory()) {
            System.out.println(directoryName + " is not a directory");
            return;
        }

        File[] files = directory.listFiles();
        if (files == null) {
            System.out.println("Directory " + directoryName + " is empty");
            return;
        }
        for (File file : files) {
            if (file.isFile() && file.getName().endsWith(".xml")) {
                transformXML(file, curDirectory);
            }
        }
    }

    public static void transformXML(File inputFile, String outputDir) {
        try {
            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(new File(inputFile.getPath()));


            NodeList newDoc = doc.getElementsByTagName("abstractGroup");
            Node node = newDoc.item(0);

            if(node == null){
                System.out.println("File " + inputFile.getName() + " does not have an abstractGroup tag");
                return;
            }

            Document doc2 = node.getOwnerDocument();

            String curDirectory = System.getProperty("user.dir");
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Source xsltSource = new StreamSource(new File(curDirectory + "/transform.xslt"));
            Transformer transformer = transformerFactory.newTransformer(xsltSource);
            DOMSource xmlSource = new DOMSource(doc2);
            Source inputSource = new StreamSource(inputFile);

            String outputFileName = inputFile.getName().replace(".xml", ".xml");

            String resultDirectoryName = outputDir + "/result";
            File resultDirectory = new File(resultDirectoryName);

            if(resultDirectory.exists() == false){
                resultDirectory.mkdir();
            }
            File outputFile = new File(resultDirectoryName, outputFileName);

            Result outputResult = new StreamResult(outputFile);
            transformer.transform(xmlSource, outputResult);
            System.out.println("File " + inputFile.getName() + " transformed successfully");
        } catch (TransformerException e) {
            System.out.println("Error transforming file " + inputFile.getName());
            e.printStackTrace();
        } catch (ParserConfigurationException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        } catch (SAXException e) {
            throw new RuntimeException(e);
        }
    }

}
